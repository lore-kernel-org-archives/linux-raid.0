From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID halting
Date: Sat, 25 Apr 2009 09:04:56 +1200
Message-ID: <49F22978.7080302@sauce.co.nz>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>	 <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>	 <49F22035.3020507@sauce.co.nz> <f19d625d0904241328k3724b9e2i8ef0e410c0d934f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f19d625d0904241328k3724b9e2i8ef0e410c0d934f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

CoolCold wrote:

>> mkfs.xfs will will query the md device for no. of devices and stripe size
>> and automatically set this optimally (su and sw).
> 
> It will, but need dmsetup installed.

Hmm. I have never used this and from reading the man page, it looks as 
though it applies to dm devices. I am using md.

Or am I missing something here. Certainly any time I have XFS formatted 
any md RAID 5/6 device directly (no volume management), the swidth and 
sunit parameters have been set to the optimal values automatically.

Regards,

Richard
