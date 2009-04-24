From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID halting
Date: Sat, 25 Apr 2009 08:25:25 +1200
Message-ID: <49F22035.3020507@sauce.co.nz>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com> <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:

>> Also, in my reading it was suggested by several researchers the best
>> performance of an XFS file system is achieved if the stripe width of 
>> the FS
>> is set to be the same as the RAID array using the su and sw switches in
>> mkfs.xfs.
> 
> This is true of any raid aware file system.  I know how to do this for 
> ext3, but not for xfs, so I won't comment further on that.  However, the 
> stripe size is always chunk size * number of non-parity drives on a 
> parity based array.

mkfs.xfs will will query the md device for no. of devices and stripe 
size and automatically set this optimally (su and sw).

If an array is later grown, these two values will need to be manually 
calculated and then be applied as mount options.

Regards,

Richard
