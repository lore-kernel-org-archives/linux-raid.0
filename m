From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 18:16:08 +0100
Message-ID: <20050318171608.GA28494@percy.comedia.it>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20050318134255.GS18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 18, 2005 at 02:42:55PM +0100, Lars Marowsky-Bree wrote:
>The problem is for multi-nodes, both sides have their own bitmap. When a
>split scenario occurs, and both sides begin modifying the data, that
>bitmap needs to be merged before resync, or else we risk 'forgetting'
>that one side dirtied a block.

on a side note i am wondering what would the difference be on using this
approach within the md driver versus DRBD?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
