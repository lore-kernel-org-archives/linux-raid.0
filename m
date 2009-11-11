From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 16:02:32 +0000
Message-ID: <4AFAE018.7040100@anonymous.org.uk>
References: <20091111145233013.LCTM5263@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111145233013.LCTM5263@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/11/2009 14:52, Leslie Rhorer wrote:
>> On 11/11/2009 08:53, Leslie Rhorer wrote:
[...]
>> risk of downtime anyway because your filesystem root is on a non-RAID
>> device, but while you can (as I think you've said before) replace the
>> boot disc quickly, you're exposing yourself to a long, slow resync which
>> will increase your downtime by perhaps days...
> 
> 	That presumes a loss of the boot drive *AND* one or two RAID drives.
> That's pretty unlikely, unless something really nasty happens.

I don't think it does - even if none of the RAID drives goes, the system 
crashing because of the root drive going AWOL might well leave the 
system with the RAID array marked "dirty" because it wasn't shut down 
cleanly, which without the bitmap would mean you'd get a full resync 
when you rebooted.

Cheers,

John.
