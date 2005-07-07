From: Eric Pretorious <eric@pretorious.net>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Thu, 7 Jul 2005 11:49:53 -0700
Message-ID: <200507071149.54019.eric@pretorious.net>
References: <200506300210.j5U2Acp04142@www.watkins-home.com> <200506301014.11454.eric@pretorious.net> <87r7eex14d.fsf@pumba.bayour.com>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r7eex14d.fsf@pumba.bayour.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Turbo Fredriksson <turbo@bayour.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 04 July 2005 04:27 am, Turbo Fredriksson wrote:
>WHY are you putting multiple md's on the same disks? Did you intend to
>do something like this?
>
>   md0          /boot      sd[ab]1
>   md1          /          sd[ab]2
>   md2          /usr       sd[ab]3
>   md3          /var       sd[ab]4
>
>Just one question (this is the magic :). What do you gain by this? And
>why do you do it?

I'm just trying to mirror two disks - that's all. Is there a better way?

-- 
Eric P.,
Truckee, CA
