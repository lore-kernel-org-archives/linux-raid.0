From: AndyLiebman@aol.com
Subject: Re: XFS RAID only writing half the time
Date: Tue, 25 Nov 2003 12:41:23 EST
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <114.2c0b3fa3.2cf4ee43@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-xfs-bounce@oss.sgi.com>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: hvisage@envisage.co.za
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Hendrik, 

Thanks for that suggestion. I tried it. Went to Google and under "vm.bdflush" 
found some documentation (http://www.faqs.org/docs/securing/chap6sec68.html) 
that explained what the various numbers mean. I didn't understand them all, 
but when I experimented and put in: 

10  1200  0  0   500     3000    60      20      0  (Just changed the first 
two figures) 

I noticed when looking at XOSVIEW that now I was writing to the disks about 
two or three times more often, and I guess writing smaller amounts of 
information each time. And the video capture lasted much longer than it did with the 
default Mandrake 9.2 setting (exactly the numbers you typed below, by the way). 

So now, do you know of any logical way to tweak these different values? I'm 
not sure that the second value of 1200 makes too much sense for what I'm trying 
to do. It seems like the higher the number in that position, the more 
"bursty" the writes are. 

I'm going to want to try to come up with some settings that allow capturing 
uncompressed video (18 MB/sec) while one or two other users are trying to read 
DV video (3.5 MB/sec) from the same drives. I guess that means I will want get 
the cache written to disk as soon as possible (leaving margin for difficult 
moments) while allowing other users to read from the disk on demand. In some 
ways, reading video files is more demanding than writing -- because what is read 
MUST arrive at the client computer exactly when needed. 

Also, do you know how Samba settings and TCP/IP settings could interact with 
this bdflush setting? I am using Samba 3.0.0 by the way. 

It's exciting that you can do all this tweaking in Linux. I'm a total newbie. 
But it's also a little daunting. 

Thanks again
Andy Liebman




> Although data is coming into my Linux machine at a rate of 18 MB/sec, I 
don't 
> see any disk activity for as much as 30 or 40 seconds after I begin 
recording 
> video. Looking at XOSVIEW, I can see on the memory display that the cache 
> fills up until my memory is almost entirely full, and ONLY THEN does the 
disk 
> writing activity begin. 
> 
> Usually this is fine, but once in a while -- after capturing video for 20 
> minutes or so, the system will have a "hiccup" and fail to write data fast 
> enough. My video editing application will then stop capturing. I don'

Play with the settings of: 
sysctl -a | grep vm.bdflush
vm.bdflush = 30 500    0       0       500     3000    60      20      0    
I've found the right settings would alleviate this hiccup issue.

HEndrik
