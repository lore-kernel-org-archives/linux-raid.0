From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 19:11:11 +0100
Message-ID: <vi6ug2-f2t.ln1@news.it.uc3m.es>
References: <20050319162443.GR18819@marowsky-bree.de> <200503191744.j2JHiKT25357@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> I agree, but I don't think a block device can to a re-sync without
> corrupting both.  How do you merge a superset at the block level?  AND the 2

Don't worry - it's just a one-way copy done efficiently (i.e., leaving
out all the blocks known to be unmodified both sides).

Peter

