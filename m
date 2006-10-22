From: Nix <nix@esperi.org.uk>
Subject: Re: why partition arrays?
Date: Sun, 22 Oct 2006 17:02:20 +0100
Message-ID: <87fydgbapf.fsf@hades.wkstn.nix>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
	<20061021062648.23c0bd7a@30_bodo.rupinet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061021062648.23c0bd7a@30_bodo.rupinet> (Bodo Thiesen's message of "21 Oct 2006 05:27:04 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Bodo Thiesen <bothie@gmx.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>, Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

On 21 Oct 2006, Bodo Thiesen yowled:
> was hdb and what was hdd? And hde? Hmmm ...), so we decided the following 
> structure:
> 
> hda -> vg called raida -> creating LVs called raida1..raida4
> hdb -> vg called raidb -> creating LVs called raidb1..raidb4

I'm interested: why two VGs? Why not have one VG covering all RAID arrays,
and then another one for any unRAIDed space (if any)?

-- 
`When we are born we have plenty of Hydrogen but as we age our
 Hydrogen pool becomes depleted.'
