From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 5 On Linux
Date: Fri, 25 Jul 2003 13:24:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16160.41685.709686.888915@gargle.gargle.HOWL>
References: <16160.37915.55072.524606@gargle.gargle.HOWL>
	<45881.202.158.96.2.1059103113.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from c4c3m@oke.net.id on Friday July 25
To: c4c3m@oke.net.id
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, c4c3m@oke.net.id wrote:
> the version mdadm that i use is mdadm-1.2.0 and i did make mdadm.static then
> make install..but it still need library when i load from faulty machine ( i
> try install mdadm-1.2.0 from debian 3.0 machine and red hat 9 machine). any
> suggestion ??

   make mdadm.static
makes a program called "mdadm.static"
   make install
installs "mdadm".

You have to 
   make mdadm.static

and then just run the program called "mdadm.static" that was created.

NeilBrown
