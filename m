From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 5 reshape stalled at 77.5% - next steps??
Date: Sat, 28 Jan 2017 18:58:57 -0500
Message-ID: <CAF-KpgaXQCjdUnsLjcC55kOCrzFgh5rPFuW8HpoUT4YNsbBELw@mail.gmail.com>
References: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
 <20170129041559.723d8259@natsu> <CAF-KpgbmnOmbCXDi6_xr9d9Ms5rFt+D3WN=3gu=7xFv0G6U5vw@mail.gmail.com>
 <20170129043338.235723a7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170129043338.235723a7@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

On Sat, Jan 28, 2017 at 6:33 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sat, 28 Jan 2017 18:29:32 -0500
> George Rapp <george.rapp@gmail.com> wrote:
>
>> Attempting to re-add /dev/sdg4 to the array fails on a busy device:
>>
>> # mdadm --manage /dev/md4 --re-add /dev/sdg4
>> mdadm: Cannot open /dev/sdg4: Device or resource busy
>
> You need to remove it first
>
>   mdadm --remove /dev/md4 /dev/sdg4
>
> or
>
>   mdadm --remove /dev/md4 faulty
>
> But honestly I am not sure if simply removing and re-adding will bring your
> reshape back to its working order at this point.
>
> Also you should figure out why did it fail in the first place. Check
> SMART, check dmesg further back rather than a few lines only. Maybe the disk
> needs a replacement, not just a blind re-add.

Perhaps not surprisingly, the --remove command also hung.

/dev/sdg4 apparently suffered an uncorrectable read error. Entire
dmesg output (2172 lines) is at
https://app.box.com/s/7brp7c53a51zw4ez5to0m12oc5hxeq92 for your
reference.

Since none of the mdadm commands will respond, I'm thinking we need to
reboot the machine at this point to do any more diagnostics.

Thanks for your quick replies!

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
