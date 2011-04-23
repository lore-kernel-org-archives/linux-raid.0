From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: debian software raid1
Date: Sat, 23 Apr 2011 10:33:20 +0200
Message-ID: <4DB28ED0.40702@computer.org>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DADB24F.2030300@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/11 18:03, Iordan Iordanov wrote:
> There are articles that propose mirroring partitions independently
> (rather than the entire disk), and not mirroring swap, but adding two
> swap partitions with equal priority.

Adding two swap partitions with equal priority is swap's way of 
implementing striping rather than mirroring.

So it depends what you're after: if you want as much swap space as 
possible then don't use md for swap and just create several swap 
partitions with equal priority. If on the other hand you're after 
robustness, in particular including the ability for the server to 
survive disk failure, then you will need to add a RAID layer.

You can of course do both. In a previous machine I had a 4-disk RAID5. 
On each of the 4 disks I had also set aside some space, which I 
organised into two 2-partition RAID0 devices, which I then used as swap 
devices with equal priority.

I have not experienced any deadlock issues with this setup.

Jan
