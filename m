From: Troy Cauble <troycauble@gmail.com>
Subject: Re: problem growing raid-1
Date: Sun, 1 Feb 2009 14:12:46 -0500
Message-ID: <6d344ffd0902011112u127fef9ay847d3541c3f15de9@mail.gmail.com>
References: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
	 <4985F070.10105@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4985F070.10105@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 1, 2009 at 1:56 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> Troy Cauble wrote:
>>
>> I want to replace both disks in a RAID-1 with larger ones using the
>> instructions here:
>>
>> http://linux-raid.osdl.org/index.php/Growing#Extending_an_existing_RAID_array
>>
>> It looks straightforward: mdadm -f, mdmadm -r, swap a drive, etc., etc.
>>
>> Except if I -f & -r a drive, I won't know which physical drive to pull.
>> (And I have no spare SATA ports.)
>
> smartctl -a -d ata /dev/sdx
>
> will tell you the serial number of the drive, which then lets you shutdown,
> identify and remove the correct one.
>
> Regards,
>
> Richard

Thanks,

Since my original post, I found out about getting the serial number
via smartctl or hdparm.

But before I start failing and removing drives, I'd like to understand
why my set up didn't handle a physically removed drive.  Because
if that happens after the -f & -r, then I'm really stuck.

Thanks,
-troy
