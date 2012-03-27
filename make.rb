#!/usr/bin/env ruby

class String
  def surround(c1,c2=c1)
    c1+self+c2
  end
end

module Kernel
  def simple_exec(argv)
    cmd, *args = *argv
    puts "Executing #{cmd} #{args.map{|x| x.surround('"')}.join(' ')}"
    system(cmd,*args)
  end
end

################################################################################
#
# TODO
#  fix $HOME and $OSTYPE in valgrindrc, cabal/config, and other files that
#  don't do expansion

{
  'dircolors/dircolors'                => '~/.%f',
  'git/gitconfig'                      => '~/.%d/%f',
  'git/gitignore'                      => '~/.%d/%f',
  'haskell/ghci'                       => '~/.%f',
  'haskell/haskeline'                  => '~/.%f',
  'htop/htoprc'                        => '~/.%f',
  'gnupg/gpg.conf'                     => '~/.%d/%f',
  'inputrc/inputrc'                    => '~/.%f',
  'pentadactyl/pentadactylrc'          => '~/.%f',
  'profile/profile'                    => '~/.%f',
  'profile/profile.darwin11.0'         => '~/.%f',
  'profile/profile.linux-gnu'          => '~/.%f',
  'profile/profile.aliases'            => '~/.%f',
  'profile/profile.aliases.darwin11.0' => '~/.%f',
  'ruby/irbrc'                         => '~/.%f',
  'ruby/rvmrc'                         => '~/.%f',
  'urxvt/font-size'                    => '~/.%d/%f',
  'urxvt/highlight-focused'            => '~/.%d/%f',
  'urxvt/mark-and-yank'                => '~/.%d/%f',
  'urxvt/mark-yank-urls'               => '~/.%d/%f',
  'vim/update_bundles'                 => '~/.%d/%f',
  'vim/vimrc'                          => '~/.%f',
  'vim/lvimrc'                         => '~/.%f',
  'xorg/Xdefaults'                     => '~/.%f',
  'xorg/xinitrc'                       => '~/.%f',
  'valgrind/valgrindrc'                => '~/.%f',
  'valgrind/suppression/darwin11.0'    => '~/.%d/%f',
  'valgrind/suppression/linux-gnu'     => '~/.%d/%f',
  'zsh/10_zshopts'                     => '~/.%d/%f',
  'zsh/20_environment'                 => '~/.%d/%f',
  'zsh/30_binds'                       => '~/.%d/%f',
  'zsh/40_completion'                  => '~/.%d/%f',
  'zsh/50_aliases'                     => '~/.%d/%f',
  'zsh/60_prompt'                      => '~/.%d/%f',
  'zsh/functions/_cabal'               => '~/.%d/%f',
  'zsh/functions/_ghc'                 => '~/.%d/%f',
  'zsh/zshrc'                          => '~/.%f',
}.to_a.sort.each do |src,expr|
  full_src_fn  = File.basename(src)
  full_src_dir = File.dirname(src)

  dst = [
    ['%d',full_src_dir],
    ['%f',full_src_fn ],
  ].inject(expr) do |expr,(token,str)|
    expr.gsub(token,str)
  end

  full_dst     = File.expand_path(dst)
  full_dst_dir = File.dirname(full_dst)

  simple_exec ['mkdir', '-p', full_dst_dir]
  simple_exec ['diff', src, full_dst]
  if $? != 0
    simple_exec ['cp', '-i', src, full_dst]
  end
end
