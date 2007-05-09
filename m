From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Recovery of software RAID5 using FC6 rescue?
Date: Wed, 09 May 2007 15:34:50 +0400
Message-ID: <4641B1DA.7030607@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>	<17984.29974.116526.922404@notabene.brown>	<7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>	<4640D7E0.9010102@msgid.tls.msk.ru> <87vef2wlw3.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vef2wlw3.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: "Mark A. O'Neil" <mark.a.oneil@Dartmouth.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix wrote:
> On 8 May 2007, Michael Tokarev told this:
>> BTW, for such recovery purposes, I use initrd (initramfs really, but
>> does not matter) with a normal (but tiny) set of commands inside,
>> thanks to busybox.  So everything can be done without any help from
>> external "recovery CD".  Very handy at times, especially since all
>> the network drivers are here on the initramfs too, so I can even
>> start a netcat server while in initramfs, and perform recovery from
>> remote system... ;)
> 
> What you should probably do is drop into the shell that's being used to
> run init if mount fails (or, more generally, if after mount runs it

That's exactly what my initscript does ;)

chk() {
  while ! "$@"; do
    warn "the following command failed:"
    warn "$*"
    p="** Continue(Ignore)/Shell/Retry (C/s/r)? "
    while : ; do
      if ! read -t 10 -p "$p" x 2>&1; then
        echo "(timeout, continuing)"
        return 1
      fi
      case "$x" in
        [Ss!]*) /bin/sh 2>&1 ;;
        [Rr]*) break;;
        [CcIi]*|"") return 1;;
        *) echo "(unrecognized response)";;
      esac
    done
  done
}

chk mount -n -t proc proc /proc
chk mount -n -t sysfs sysfs /sys
...
info "mounting $rootfstype fs on $root (options: $rootflags)"
chk mount -n -t $rootfstype -o $rootflags $root /root
if [ $? != 0 ] && ! grep -q "^[^ ]\\+ /root " /proc/mounts; then
  warn "root filesystem ($rootfstype on $root) is NOT mounted!"
fi
...

> hasn't ended up mounting anything: there's no need to rely on mount's
> success/failure status). [...]

Well, so far exitcode has been reliable.

/mjt
