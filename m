From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Problems with a RAID5 array
Date: Tue, 25 Oct 2016 13:48:24 +0100
Message-ID: <580F5498.40902@youngman.org.uk>
References: <5C95474C-8A2A-4472-9629-2DD6B2143D28@GMAIL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5C95474C-8A2A-4472-9629-2DD6B2143D28@GMAIL.COM>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Nicolaou <nicolaoun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/10/16 08:45, Nicolas Nicolaou wrote:
> Hi all,
> 
> I am a newbie in the RAID field but i encountered some problems 
> with my RAID5 configuration on a QNAP NAS machine. 
> 
> In particular i added a 3TB drive and the array seemed to be rebuilt 
> automatically. Originally i had 3 3TB drives on it. 
> The rebuilt finished and i was able to access my data. For some weird reason
> one of the drives was not added and i tried to expand the RAID capacity. 
> The expand failed but still no problems...
> 
> When i rebooted the system however the RAID became inactive and 
> now i cannot access any of the data. 
> 
> Below you can see the mdadm —examine information for the 4 drives. 
> 
> I saw a thread that recreating the RAID may solve the issue 
> (https://raid.wiki.kernel.org/index.php/RAID_Recovery). 
> Before going to that path though i wanted to see your take. 
> 
Firstly, using "--force" is not necessarily a bad idea, though you want
to avoid it if you can. Using "--create" is an absolutely crazy idea
unless you are being hand-held by an expert. DO NOT attempt that on your
own unless you really want to lose everything.

Secondly, if you *are* going to be mad enough to try "--create", make
sure you've run Phil's lsdrv utility and you have a hard copy of the
output saved somewhere safe!

Go back to the raid wiki, go to the home page, and read section 4, "When
things go wrogn". Read the entire section. It includes the page you've
referenced, but that's an old page that will be deprecated. It's a
moderately safe bet that when the experts chime in, they will want a lot
of the information that tells you to gather. And hopefully, working
through this will give you a few clues yourself.

Cheers,
Wol
