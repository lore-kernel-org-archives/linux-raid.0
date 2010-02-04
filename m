From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to support handoff after pivotroot
Date: Thu, 4 Feb 2010 14:50:13 +0100
Message-ID: <201002041450.14139.bernd.schubert@fastmail.fm>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <4B6847EA.8010509@tmr.com> <4B686CC0.4030103@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B686CC0.4030103@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 02 February 2010, Doug Ledford wrote:
> On 02/02/2010 10:42 AM, Bill Davidsen wrote:
> > Michael Evans wrote:
> > It seems as if a lot of work
> > and overhead is being generated for the applications, just to save a
> > tiny bit of work for the people implementing a new boot procedure.
> >
> > (cd /dev .run && find . -depth | cpio -pdm /var/run; cd -; rmdir
> > /dev/.run)

What about to use "mount --move" from /var/run of the initrams to final 
/var/run before the chroot command?


Cheers,
Bernd
