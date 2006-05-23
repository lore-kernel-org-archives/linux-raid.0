From: Ste <ste@phx6a.ath.cx>
Subject: Re: mdadm: bitmap size
Date: Tue, 23 May 2006 12:13:40 +0200
Message-ID: <4472E054.5050007@phx6a.ath.cx>
References: <446D0119.1010508@phx6a.ath.cx>	<17517.2191.803890.424144@cse.unsw.edu.au>	<91ebddcf0605211608i1145d957g65b18b3caa68cfc@mail.gmail.com> <17520.63317.693491.212555@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17520.63317.693491.212555@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> (Please don't reply off-list.  If the conversation starts on the list,
> please leave it there unless there is a VERY GOOD reason).
>   
Sorry this wasn't my intent.
> raidhotadd doesn't know anything about bitmaps.
> If you use 'mdadm /dev/mda --add /dev/nda' you should find that it
> works better.
>
> I recommend getting rid of setfaulty / raidhotadd /raidhotremove etc
> and just using mdadm.
>   
Okay, thankyou. :-)

Stefano.
