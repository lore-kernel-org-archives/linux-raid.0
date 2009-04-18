From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 12:19:54 +0200
Message-ID: <20090418101954.GA1448@maude.comedia.it>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090418083609.GA4436@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 10:36:09AM +0200, Piergiorgio Sartor wrote:
>The cause is "num-devices", which is set by the
>"--examine --scan" or "--detail --scan".

i believe the num-devices is redundant since this value is already
stored in the superblock
we could change the way mdadm outputs data to put _all_ redundant
information in subsequent lines and keep the only required info in the
'ARRAY' line,
so mdadm --examine --scan | grep ARRAY would be suitable for initial
configuration
or even print it only if a --verbose flag is added
so mdadm --examine --scan by itself would suit most need

for the time being some akw magic can be used to parse 'mdadm --examine
--scan' and make it suitable for inclusion in mdadm.conf

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
