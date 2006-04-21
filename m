From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Fri, 21 Apr 2006 19:45:29 -0300
Message-ID: <17481.24713.400927.636615@fisica.ufpr.br>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
	<17474.54168.331725.412456@cse.unsw.edu.au>
	<20060420143545.GB27744@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060420143545.GB27744@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor Gombas (gombasg@sztaki.hu) wrote on 20 April 2006 16:35:
 >On Mon, Apr 17, 2006 at 09:30:32AM +1000, Neil Brown wrote:
 >
 >> It is arguable that for a read error on a degraded raid5, that may not
 >> be the best thing to do, but I'm not completely convinced.
 >
 >My opinion would be that in the degraded case md should behave as if it
 >was a single physical drive, and just pass the error to the upper layers.
 >Then the filesystem can decide what to do (for example, ext3 can be told
 >to just continue, remount read-only, or simply panic).

Agreed. This makes for a nice conceptual separation: raid is only a
matter of disk redundancy, independent of the rest.
