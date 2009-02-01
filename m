From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: problem growing raid-1
Date: Mon, 02 Feb 2009 07:56:48 +1300
Message-ID: <4985F070.10105@sauce.co.nz>
References: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Cauble <troycauble@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Troy Cauble wrote:
> I want to replace both disks in a RAID-1 with larger ones using the
> instructions here:
> http://linux-raid.osdl.org/index.php/Growing#Extending_an_existing_RAID_array
> 
> It looks straightforward: mdadm -f, mdmadm -r, swap a drive, etc., etc.
> 
> Except if I -f & -r a drive, I won't know which physical drive to pull.
> (And I have no spare SATA ports.)

smartctl -a -d ata /dev/sdx

will tell you the serial number of the drive, which then lets you 
shutdown, identify and remove the correct one.

Regards,

Richard
