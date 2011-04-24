From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQgUkFJRDUtYXNraW5nIGZvciBz?=
 =?UTF-8?B?b21lIGFzc2lzdGFuY2U=?=
Date: Sun, 24 Apr 2011 01:37:53 +0100
Message-ID: <4DB370E1.5030602@anonymous.org.uk>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>	<ioq2b8$3rl$1@dough.gmane.org>	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>	<20110422125734.1a68a736@notabene.brown>	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>	<20110423074411.78fef94f@notabene.brown>	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>	<20110423184824.55ee7893@notabene.brown>	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>	<20110424075101.6763309f@notabene.brown> <BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/2011 01:07, John Valarti wrote:
> On Sat, Apr 23, 2011 at 3:51 PM, NeilBrown<neilb@suse.de>  wrote:
[...]
>> I really cannot help you until you show me the output of "mdadm --assemble
>> --verbose ..." like I asked.
>>
>> NeilBrown
>
> I really WAS NOT lying!
>
> I just did it again, and redirected output to a file
>
> The file ( located on my USB stick) contains:
>
> mdadm: looking for devices for /dev/md1
> mdadm: no devices found for /dev/md1

If I can butt in here... presumably while the system can't assemble your 
array, you're running from rescue media or whatever? You may not have a 
suitable mdadm.conf in the rescue environment.

If you haven't already posted `mdadm --examine --scan --verbose 
--verbose` aka `mdadm -Esvv`, or at the very least `mdadm --examine 
--verbose /dev/sd[abc][12]`, then please do.

Please also try `mdadm --assemble --scan --verbose` and post the result.

Another thing that occurs to me is that since you said you had CentOS 4, 
you likely have kernel 2.6.9 and mdadm 1.12 which are very old. You 
might try SystemRescueCD or similar to get a mdadm 3.1.x which will be 
much better at finding and fixing any problems.

Cheers,

John.

