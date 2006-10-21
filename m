From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: why partition arrays?
Date: Sat, 21 Oct 2006 15:39:58 +0200
Message-ID: <453A232E.8050401@idgmail.se>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk> <20061021062648.23c0bd7a@30_bodo.rupinet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061021062648.23c0bd7a@30_bodo.rupinet>
Sender: linux-raid-owner@vger.kernel.org
To: Bodo Thiesen <bothie@gmx.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>, Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

Bodo Thiesen wrote:
> Ken Walker <ken.walker@manchester.ac.uk> wrote:
> 
>> Is LVM stable, or can it cause more problems than separate raids on a array.

[description of street smart raid setup]

(The same function could probably be achieved with logical partitions
and ordinary software raid levels.)

> So, now decide for your own, if you consider LVM stable - I would ;)
> 
> Regards, Bodo

Have you lost any disc (i.e. "physical volumes") since February? Or lost
the meta-data?

I would not recommend anyone to use LVM if they are less than experts on
Linux systems. Setting up a LVM system is easy: administrating and
salvaging the same, was much more work. (I used it ~3 years ago)

/Henrik Holst
