From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata updates
Date: Mon, 23 Feb 2009 11:58:50 -0700
Message-ID: <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
	 <18822.13389.938876.964972@notabene.brown>
	 <1235404451.751.383.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1235404451.751.383.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 23, 2009 at 8:54 AM, Doug Ledford <dledford@redhat.com> wrote:
> On Mon, 2009-02-02 at 10:46 +1100, Neil Brown wrote:
>> We really need a man page for mdmon don't we.  Then this sort of text
>> could be placed there for safely.
>
> Yes, a man page is definitely needed.

I have one brewing, I'll include it in an upcoming pull request.

> I have no intention of putting
> mdmon in the initramfs.  The only arrays that should be started during
> initramfs operation are / and possibly /boot.  Both of those are started
> readonly.  It isn't until later in the boot process (in rc.sysinit on
> Fedora/RHEL) that we remount the / device rw.  It's my intention to
> modify our rc.sysinit so that before the root device goes rw, we start
> the necessary mdmon instances.  This should be sufficient to keep the
> container metadata state consistent with reality and avoids having to
> add mdmon to the initramfs.  However, that means I need to know how to
> invoke mdmon when mdadm isn't starting it for me.

Did you happen to catch the discussion on the initramfs mailing list
[1]?  It would be nice to not need mdmon in the initramfs.  However, I
have found it needs to be there because even read-only mounted
filesystems require write access to the underlying block device to
recover the journal.

--
Dan

[1] http://thread.gmane.org/gmane.linux.kernel.initramfs/65/
