From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Wed, 10 Dec 2008 21:46:45 -0500
Message-ID: <49407F15.4000105@openhardware.net>
References: <4931B2C5.5060403@openhardware.net> <20081130080752.GA19919@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081130080752.GA19919@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Sat, Nov 29, 2008 at 04:23:17PM -0500, Tom Walsh wrote:
>> <sigh> I need help!
> 
> i'll try :(
>> I've overhauled the software, replaced the operating system
>> innumerable times with several Mandriva distros: 2008, 2008.1, 2009.
>> Removed the Mandriva kernel and compiled a stock 2.6.27.7 from
>> ftp.kernel.org.  Ran the Seagate SeaTools on all four drives, no
>> errors.  Ran the Western Digital Date Lifeguard on the two drives, no
>> errors.  Changed from raid5 to raid10, still resyncs on boot.
> 
> https://qa.mandriva.com/show_bug.cgi?id=40023
> 
> read the whole of it.
> 

FWIW, this problem with udev seems to be a tricky one to resolve.  After 
test driving the new KDE4 desktop, I ran screaming back to the earlier 
KDE3 (to get work done, not look at eye-candy).  The problem with the 
raid10 volume appeared again in a differnet form.  All partitions within 
the array came up as spares.

Downloading and installing mdadm v2.6.8 Nov 28 2008 cured this.

The array is assembling properly at boot, no changes to scripts or udev. 
  The array does have an internal bitmap though, holdover from last time.

TomW


-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

