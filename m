From: Tao Guo <glorioustao@gmail.com>
Subject: Data scribbling for raid6 is wrong?
Date: Thu, 15 Dec 2011 11:15:42 +0800
Message-ID: <CAAV8rnKoga_DM1qh28ZGEsJMZAKPYDZcVFfLBSH9kPNHysf7LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Today I checked the raid6's scribbling code, and I think there may be
some improvements to handle bad sectors:

If we have one bad sector(with corrupted data) in the data block,
scribbling thread will find parity mismatch and will try to
recompute&rewrite P&Q, but that will cause final data loss.
Since we have P & Q,=C2=A0 actually we can try to use them and find out=
 the
wrong data block then fix it.

But the algorithm to find the bad data block seems not
straightforward... Does anyone know if there is any paper discussed
this issue before?

Update: I just found there is one talk about this in FAST08:
http://www.usenix.org/events/fast08/tech/krioukov.html.
But that approach will add checksums.etc. For bare-bones raid6, does
any guru have any better ideas?

Thanks,
-Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
