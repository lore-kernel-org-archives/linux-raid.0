From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: help!
Date: Mon, 14 Nov 2005 16:55:24 -0200
Message-ID: <17272.56732.538446.471537@fisica.ufpr.br>
References: <4378C76A.9070906@trinitybiblecollege.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4378C76A.9070906@trinitybiblecollege.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shane Bishop (sbishop@trinitybiblecollege.edu) wrote on 14 November 2005 11:20:
 >I had an mdadm device running fine, and had created my own scripts for 
 >shutting it down and such. I upgraded my distro, and all of a sudden it 
 >decided to start initializing md devices on it's own, which include one 
 >that I want removed.

Probably the filesystem type in the partition table is set to raid
autodetect (fd). Try changing it to something else, for example 83.
Note that these are hexadecimal numbers.
