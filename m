From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 rebuild with only 2 spare devices
Date: Sat, 12 Feb 2011 13:48:54 -0500
Message-ID: <4D56D616.1050006@turmel.org>
References: <4D542872.3090102@gmail.com>	<4D544586.4010506@anonymous.org.uk> <AANLkTi=UxgH1nWyeCWjiHJtLCqiQx6iNtN0HJ9uCyADT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=UxgH1nWyeCWjiHJtLCqiQx6iNtN0HJ9uCyADT@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Heilberg <theilberg42@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/12/2011 01:30 PM, Thomas Heilberg wrote:
> 2011/2/10 John Robinson <john.robinson@anonymous.org.uk>:
> 
>> Those loop devices are now trashed since you didn't re-create the array with
>> exactly the parameters with which it was initially created. Your settings
>> make me think the array was created with an older version of mdadm; the
>> defaults for metadata version and chunk size changed a little while ago.
>> Anyway, if you're trying again, you should specify -e 0.90 -c 64. While
>> you're at it, add --assume-clean to avoid any rebuild, which in your case
>> may in fact destroy good data (though the array's parity would end up
>> consistent). Or if as you noted in your other reply you're going to have to
>> wait 15 hours before trying anything, maybe wait until The Boss[1] makes a
>> more intelligent suggestion than I can; he usually posts at times that
>> appear to be overnight to me but are presumably sensible times of day for
>> him.
> 
> It worked! Although I am not quite sure why.

Wonderful!

[trim /]
 
> But there is one thing I don't understand. I did that recreating act 2
> times. The first time it didn't work and I had to restore the
> raid-partitions from my backup(this time onto a btrfs partition in the
> hope I could use its snapshot feature) and then it worked. Is it
> possible that the order of the devices is important for the recreate
> process?
> I mean mdadm -C... /dev/loop1 /dev/loop0 /dev/loop2 instead of the
> normal order? Because I did that by mistake(or to be more precise I
> "mounted" the second image into loop0)

Yes, the order of devices matters for "create".  With the original images, "mdadm -E" on each should report which "slot" or raid device number they expect to be.  That's used in normal assembly to keep everything in order (the kernel doesn't guarantee consistent block device names or load order).

So, if you are recreating an array (with --assume-clean), you need to specify them in the same order that "mdadm -E" sees.

Phil
