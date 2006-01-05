From: Francois Barre <francois.barre@gmail.com>
Subject: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 10:06:59 +0100
Message-ID: <fd8d0180601050106s5f5b4306o@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050104x15079396h@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Well, I think everything is in the subject... I am looking at this
solution for a 6*250GB raid5 data server, evolving in a 12*250 rai5 in
the months to come... Performance is absolutely not a big issue for
me, but I would not appreciate any data loss.
Furthermore, I would prefer not to use LVM nor any middle layer
between MD and the fs... Is this middle layer *very* usefull when I'm
sure my partitions layout will not evolve (e.g. only one enormous fs)
?
Thanks for your answerings/advices,

F.-E.B.
