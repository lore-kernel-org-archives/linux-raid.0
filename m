From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier (GiB alignment)
Date: Sat, 17 Mar 2012 22:39:31 +0100
Message-ID: <4F650493.7080709@gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com> <4F61803A.60009@hardwarefreak.com> <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com> <20321.63389.586851.689070@tree.ty.sabi.co.UK> <CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com> <20322.29849.917554.794740@tree.ty.sabi.co.UK> <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com> <20324.44842.473837.511238@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20324.44842.473837.511238@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Dne 17.3.2012 16:35, Peter Grandi napsal(a):
> I often recommend aligning partitions to 1GiB, also because I
> like to have 1GiB or so of empty space at the very beginning and
> end of a drive.

I'm really curious why do you use such alignment? I can think about few
reasons, but most practical I think you like to slice in gigabyte sizes.

Z.
