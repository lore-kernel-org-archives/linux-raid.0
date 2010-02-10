From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Wed, 10 Feb 2010 08:06:13 -0800
Message-ID: <4877c76c1002100806w66e504deg767f6ecc8cc7fa8a@mail.gmail.com>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <4B6DAC06.6060909@redhat.com>
	 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	 <4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown>
	 <20100209021949.GB11780@lapse.rw.madduck.net>
	 <4B71C6CA.3010407@redhat.com>
	 <alpine.LNX.2.01.1002091553580.10004@filesrv1.baby-dragons.com>
	 <20100210123321.324e5de6@notabene.brown>
	 <e9c3a7c21002100749u2c6d7c51qa0cc1830452f84cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21002100749u2c6d7c51qa0cc1830452f84cb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Doug Ledford <dledford@redhat.com>, linux-raid maillist <linux-raid@vger.kernel.org>, initramfs@vger.kernel.org, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On Wed, Feb 10, 2010 at 7:49 AM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Tue, Feb 9, 2010 at 6:33 PM, Neil Brown <neilb@suse.de> wrote:
>> On Tue, 9 Feb 2010 15:58:52 -0900 (AKST)
>> "Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:
>>>
>>> =A0 =A0 =A0 But that said , =A0the idea of a /'name' area for this =
is imo a very good
>>> thing . =A0Rather hiding it below others .
>>
>> Thanks.
>>
>> One idea that has occurred to me is that maybe /sys is the right pla=
ce to put
>> this stuff!!! =A0If only sysfs directories could be writeable, I cou=
ld write the
>> pid file in /sys/class/block/md0/md/mdmon.pid and create a socket wi=
th a
>> similar name.
>
> Hmm... we already have /sys/kernel/debug as a simple mount point for
> debugfs. =A0What about adding /sys/kernel/init as a mount point for t=
his
> tmpfs?
>
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Except that isn't quite accurate is it?  This is less to do with init
for the kernel and more to do with various pieces of system state
information.

/sys/early_rw

Isn't very descriptive, but might make sense.  It also might not quite
be what we want to mean, as the files in it could also linger past
root unmount as the system is brought down.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
