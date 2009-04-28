From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 11:35:47 +0200
Message-ID: <87ljplnmrw.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F68CE0.2010906@zytor.com> (H. Peter Anvin's message of "Mon,
	27 Apr 2009 21:58:08 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"H. Peter Anvin" <hpa@zytor.com> writes:

> Goswin von Brederlow wrote:
>> 
>> Or grub2 could be thought to install itself into all MBRs of all
>> drives in a raid set.
>> 
>
> ... which is obviously completely wrong, given that that would break the
> whole RAID layer.

Not if there is unused space for the MBR on every raid disk. The 1.2
metadata format leaves the first 4k free on every disk.

> The right thing is to use a RAID-1 partition.
>
> 	-hpa

And how do you create a raid-1 partition on a whole disk raid?

MfG
        Goswin
