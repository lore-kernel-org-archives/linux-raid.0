From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 23:55:09 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15660.15549.501687.976304@notabene.cse.unsw.edu.au>
References: <15660.14403.330548.476141@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.30.0207101542380.25329-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danilo Godec on Wednesday July 10
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 10, danci@agenda.si wrote:
> On Wed, 10 Jul 2002, Neil Brown wrote:
> 
> >  mdadm --assemble --force /dev/md1 /dev/sda2 /dev/sdc2
> >
> > Then it will have to use a2 and c2.
> 
> I tried that, but it refused to do it (something about 2/3 drives
> failed)!? Maybe my mdadm version is old (v1.0.0)?

Hmmm. Should work, but might need a "--run" as well...

Can you get me an exact error message, and maybe the output of
 mdadm --examine /dev/sd[abc]2

NeilBrown
