From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: RAID-5 using CLOOP devices
Date: Wed, 28 Dec 2005 07:21:08 -0600
Message-ID: <6d5bedd80512280521v47711d7ejdf22cb60b7fc3b41@mail.gmail.com>
References: <6d5bedd80512271108q6dda3d2ax23b226caba823caa@mail.gmail.com>
	 <20051228023031.GA31926@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051228023031.GA31926@lug.udel.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/27/05, Ross Vandegrift <ross@lug.udel.edu> wrote:
> Wait - so what is the difference?
>
> Right now, you are using md to make a RAID5 of cloop devices, on
> something like a virtual environment.
>
> Soon, you'll use md to make a RAID5 of cloop devices, on a total
> physical environment.
>
> If it's working now, how could it possibly not work?
> Maybe I don't understand the situation...

The problem is that currently md doesn't think it's talking to a group
of cloop devices, it thinks it's talking to "real" devices (cbod to be
exact) that are hosting ext3 partitions. Technically, I suspect that
it "should" work to just change the membership of the RAID on the
Linux side, but given the amount of data, I'd like to avoid having to
rebuild an array and have to reload all the data.

FWIW,
Ewan
