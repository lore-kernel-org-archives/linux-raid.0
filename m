From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Mon, 05 Mar 2007 18:47:57 -0500
Message-ID: <45ECAC2D.4010404@laurelnetworks.com>
References: <45E82EF8.9000106@laurelnetworks.com> <12721.45EB026B.1040503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12721.45EB026B.1040503@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Mike Accetta wrote:
>>
>> I've been considering trying something like having the re-sync algorithm
>> on a whole disk array defer the copy for sector 0 to the very end of the
>> re-sync operation.  Assuming the BIOS makes at least a minimal 
>> consistency
>> check on sector 0 before electing to boot from the drive, this would keep
>> it from selecting a partially re-sync'd drive that was not previously 
>> bootable.
> 
> The only check that it will make is to look for 55 AA at the end of the 
> MBR.
> 
> Note that typically the MBR is not part of any of your MD volumes.

Yes, that is also what I've observed in the case of our BIOS.  I'm still
trying to get our BIOS vendor to confirm that it will fail over to the next
drive in the boot list on a read error of sector 0.  We're contemplating
some GRUB hacking to fail-over to the "other" drive once it is in control
and sees problems.

I wonder if having the MBR typically outside of the array and the relative
newness of partitioned arrays are related?  When I was considering how to
architect the RAID1 layout it seemed like a partitioned array on the
entire disk worked most naturally.
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
