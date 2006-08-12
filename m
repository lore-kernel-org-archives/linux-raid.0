From: "David Rees" <drees76@gmail.com>
Subject: Re: Resize on dirty array?
Date: Fri, 11 Aug 2006 18:11:07 -0700
Message-ID: <72dbd3150608111811u2dc3ea1dv7a3a8e148597d29e@mail.gmail.com>
References: <44D7DC93.2070905@net1plus.com>
	 <17623.57067.835826.446152@cse.unsw.edu.au>
	 <44D8E535.9080208@net1plus.com>
	 <17625.24594.568139.430440@cse.unsw.edu.au>
	 <44D9C6F5.7070501@net1plus.com>
	 <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
	 <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
	 <44D9E41C.4050608@net1plus.com>
	 <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: James Peverill <jamespev@net1plus.com>
List-Id: linux-raid.ids

On 8/10/06, dean gaudet <dean@arctic.org> wrote:
> - set up smartd to run long self tests once a month.   (stagger it every
>   few days so that your disks aren't doing self-tests at the same time)

I personally prefer to do a long self-test once a week, a month seems
like a lot of time for something to go wrong.

> - run nightly diffs of smartctl -a output on all your drives so you see
>   when one of them reports problems in the smart self test or otherwise
>   has a Current_Pending_Sectors or Realloc event... then launch a
>   repair sync_action.

You can (and probably should) setup smartd to automatically send out
email alerts as well.

-Dave
