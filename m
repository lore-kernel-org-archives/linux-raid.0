From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 23 Mar 2012 00:10:25 -0500
Message-ID: <4F6C05C1.4020204@hardwarefreak.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com> <4F61803A.60009@hardwarefreak.com> <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com> <20321.63389.586851.689070@tree.ty.sabi.co.UK> <4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard> <20325.17387.216150.45013@tree.ty.sabi.co.UK> <20325.50714.237894.328039@tree.ty.sabi.co.UK> <4F6624A3.5010206@hardwarefreak.com> <20331.39194.377610.888636@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20331.39194.377610.888636@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 3/22/2012 4:26 PM, Peter Grandi wrote:

[snipped 2-3 pages of redundant nonsense, linked docs, and filesystem
concepts everyone is already familiar with]

> Overselling 'delaylog' with cheeky propaganda glossing over the
> heavy tradeoffs involved is understandable, but quite wrong.

And now we come full circle to what started this mess of a discussion:
Peter's dislike of Dave's presentation of delaylog, and XFS in general,
at linux.conf.au.

Peter, if *you* had been giving Dave's presentation at linux.conf.au,
how would *you* have presented delayed logging differently?  How much
time would you have spent warning of the dangers of potential data loss
upon a crash and how would you have presented it?  Note I'm not asking
you to re-critique Dave's presentation.  I'm asking you to write your
own short presentation of the delayed logging feature, so we can all see
it done the right way, without "cheeky propaganda" and without "glossing
over the heavy tradeoffs".

We're all on the edge of our seats, eagerly awaiting your expert XFS
presentation Peter.

-- 
Stan
