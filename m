From: Luca Berra <bluca@comedia.it>
Subject: Re: array always resyncs on boot
Date: Mon, 1 Dec 2008 08:47:23 +0100
Message-ID: <20081201074723.GA18651@maude.comedia.it>
References: <4931B2C5.5060403@openhardware.net> <20081130080752.GA19919@maude.comedia.it> <493261C9.8090208@openhardware.net> <493327F5.5010704@openhardware.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <493327F5.5010704@openhardware.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 30, 2008 at 06:55:33PM -0500, Tom Walsh wrote:
> Tom Walsh wrote:
>> Luca Berra wrote:
>>> On Sat, Nov 29, 2008 at 04:23:17PM -0500, Tom Walsh wrote:
>>>> <sigh> I need help!
>>>
>>> i'll try :(
>>>> I've overhauled the software, replaced the operating system
>>>> innumerable times with several Mandriva distros: 2008, 2008.1, 2009.
>>>> Removed the Mandriva kernel and compiled a stock 2.6.27.7 from
>>>> ftp.kernel.org.  Ran the Seagate SeaTools on all four drives, no
>>>> errors.  Ran the Western Digital Date Lifeguard on the two drives, no
>>>> errors.  Changed from raid5 to raid10, still resyncs on boot.
>>>
>>> https://qa.mandriva.com/show_bug.cgi?id=40023
>>>
>>> read the whole of it.
>>>
>>
>> Ahhh, yes!  Thank you!
>>
>>
>> I was reverting back to the 2008.0 distro and building a 2.6.27.7 kernel 
>> when I saw your reply.  Reading the bugzilla makes a whole lot of sense of 
>> what I was seeing in the dmesg (re: md not finishing before the raid10 
>> module started).  Finishing out that build, I found that the 2.6.27.7 
>> stock kernel would boot and NOT resync the array.  That proves, to me, 
>> something is wrong with the overall Mandriva 2009.0 system (as well as 
>> 2008.1 which also fails miserably).

It is not limited to mandriva, redhat has the same 'feature' and afair
ubuntu was also the first to implement it.

> Just a follow-up.  Add the internal bitmap to the arrays has cured the 
> problem (mdadm --grow --bitmap=internal <mdX>).  This is definitely a 
> feature that I will consider adding to the existing raid5 arrays that I 
> maintain out in the wild.
>
> Is this a non-destructive thing to do to a working array?  Grow it with 
> adding the bitmap?  I did not make each member partition of the arrays 
> consume the remainder of the drives, but left 50..150 blocks unused in them 
> (found various 250Meg drives do not all have the same block counts between 
> manufacturers).

It is a non destructive operation, it actually uses the space between
end of data and start of superblock. it does not care about 'free' space
on the drive.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
