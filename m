From: Ben Edwards <ben@serverone.co.uk>
Subject: Re: Hardware versus Software
Date: Wed, 19 May 2004 23:30:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40ABDFEC.9080802@serverone.co.uk>
References: <ac.5847806b.2ddc5d88@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac.5847806b.2ddc5d88@aol.com>
To: AndyLiebman@aol.com, Linux RAID List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

AndyLiebman@aol.com wrote:

>I'm sure this has been discussed many times on the list but I was asked this 
>question today and I'm not sure how to respond: 
>
>Under Linux (i.e., a distribution such as Mandrake 10 -- with an up-to-date 
>2.6 kernel), is a "true hardware RAID-5" created through a SATA card such as 
>the 3ware 8506 or the new 3ware 9500 series any SAFER or MORE RELIABLE than a 
>software RAID created with the same card? 
>
>In my benchmark comparisons between software and hardware RAID, I get 
>significantly better performance using "software RAID". With eight 250 GB disks, I 
>get about 175 MB/sec reading and about 150 MB/sec writing when my system is 
>configured as software RAID. With hardware RAID the figures drop to about 125/100 
>MB/sec. 
>
>I'm only using my machines as file servers, so they aren't busy doing any 
>other tasks besides sending data packets through Gigabit Ethernet and running 
>disk I/O. 
>
>But the question still remains, is there any other safety and reliability 
>advantage to using Hardware? Is the data on a Hardware RAID more likely to remain 
>intact in the event of a computer crash or freeze? 
>
>Or in the event of an abrupt power failure (I have a UPS on the system, but 
>that could fail, or the power cables could be pulled out of the computer or 
>somebody could accidently shut it down). All of these power failure scenarios are 
>very unlikely, but they COULD occur. 
>
>Would Hardware RAID survive better than Software? I can't see why, but maybe 
>I'm missing something. 
>
>In my situation where the server isn't running any other software, the only 
>advantage I can see to hardware RAID is that rebuilding in the event of a disk 
>failure is a little easier for non-experts. But I'm writing a program to 
>automate the software RAID rebuilding process so that non-experts can do it 
>themselves. 
>
>Your informed comments would be appreciated. 
>  
>
This is VERY interesting. Douse the doumentation for software raid say
it is doing true Raid 5? I would be very suprised if software raid was
faster and if it is I wold think the card is either broke or rubish
(stop me at any time if me english gets too profesional). If what you
say is the case you should circulate this in other palces (slashdot,
debian-user etc.) as I am sure other would be very interested. This list
douse not seem to be that active so not sure if you will get mutch
response here. If you find anything out be sure to let the list know.

Ben

