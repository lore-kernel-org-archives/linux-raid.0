From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID down, dont know why!
Date: Sun, 08 Nov 2009 09:24:20 -0500
Message-ID: <4AF6D494.2050207@gmail.com>
References: <4AF6CEFD.60309@gmail.com> <20091108142238.GA11786@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091108142238.GA11786@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What would I be looking for on this? Its a lot to sift through.

Currently just line-by-lining it.

Robin Hill wrote:
> On Sun Nov 08, 2009 at 09:00:29AM -0500, Andrew Dunn wrote:
>
>   
>> I just copied 4+ TiB of information to this array, restarted 5 times
>> and tried to access it.... What is going on?
>>
>> What kind of logs do you need, I really need help!
>>
>>     
> From the message you've posted, it looks like something has triggered
> the (simultaneous) removal of four drives from the array.  I'd check the
> dmesg output - it should provide some information.  I'd guess these four
> drives are all attached to the same controller (are they external or
> internal?), so possibly the controller reset (or for external drives, it
> could be a cable issue).
>
> You should be able to force an assembly anyway (using the --force flag)
> but I'd make sure you know exactly what the issue is first, otherwise
> this is likely to happen again.
>
> Cheers,
>     Robin
>   

-- 
Andrew Dunn
http://agdunn.net

