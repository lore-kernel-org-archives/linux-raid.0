From: Michal Soltys <nozo@ziu.info>
Subject: Re: Help: very slow software RAID 5.
Date: Thu, 20 Sep 2007 20:16:41 +0200
Message-ID: <46F2B909.7080903@ziu.info>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> <20070919174956.9497310209D@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709191425440.27758@p34.internal.lan> <20070919233137.7D5B2102365@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070919233137.7D5B2102365@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> 
> Also (as I asked) what is the downside?  From what I have read, random
> access reads will take a hit.  Is this correct?
> 
> Thanks very much for your help!
> 
> Dean
> 

Besides bonnie++ you should probably check iozone. It will allow you to test 
very specific settings quite thoroughly. Although with current 
multi-gigabyte memory systems the test runs may take a bit time.

http://www.iozone.org/

There's nice introduction to the progam there, along with some example graph 
results.


