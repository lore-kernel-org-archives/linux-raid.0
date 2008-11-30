From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Sun, 30 Nov 2008 04:50:01 -0500
Message-ID: <493261C9.8090208@openhardware.net>
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

Ahhh, yes!  Thank you!

I found myself heading down that path after successfully rebooting the 
machine 10 out of 10 times using a 2.6.22.9 kernel in the Mandriva 
2008.0 distro.  I then built a 2.6.22.19 kernel in the 2009.0 that would 
resync on every boot.  The problem pwrsisted with the new 2.6.22.19 kernel.

I was reverting back to the 2008.0 distro and building a 2.6.27.7 kernel 
when I saw your reply.  Reading the bugzilla makes a whole lot of sense 
of what I was seeing in the dmesg (re: md not finishing before the 
raid10 module started).  Finishing out that build, I found that the 
2.6.27.7 stock kernel would boot and NOT resync the array.  That proves, 
to me, something is wrong with the overall Mandriva 2009.0 system (as 
well as 2008.1 which also fails miserably).

<sigh>  I got nailed on this one!  I updated the machine about two 
months before I did a shutdown prior to moving to my new home.  Just 
before I left the old place, I booted this box to do some financial 
stuff and found it resync-ing the raid5 array...

Thank you again.


-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

