From: David J Craigon <david@arabidopsis.info>
Subject: Problems with IDE Software RAID
Date: Wed, 05 Nov 2003 21:20:20 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FA96994.5020406@arabidopsis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,
	I'm trying to use md with 9 Seagate 160Gb drives and a 160 Gb partition 
on a Hitachi drive that also has the operating system on it. I'm using 
an ASUS A7V600 motherboard and two Promise Ultra-100 TX2 cards.

	I'm using the beta of Fedora Core distribution (2.4.22), and I have 
also tried the 2.6.0-test9 kernels with this distribution.
	All of the drives appear to work seperately. The drives also work in 
RAID configurations of up to 5 drives in any combinations. However using 
6 drives and up results in total system lock-up. I run mkraid and  about 
two seconds later the system irretrievebly hangs. I've tried this with 
RAID 0 and RAID 5.

Has anyone got any ideas about what is wrong? How should I go about 
debugging this?

Do you think this might be related to bugzilla bug id #956 on the 
bugzilla? http://bugzilla.kernel.org/show_bug.cgi?id=956

Hoping someone can help,

David

