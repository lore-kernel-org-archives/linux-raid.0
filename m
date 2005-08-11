From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How to force a spare drive to take over in a RAID5?
Date: Thu, 11 Aug 2005 20:11:21 +1000
Message-ID: <17147.9289.214312.837092@cse.unsw.edu.au>
References: <45138.213.188.237.106.1123086677.squirrel@localhost>
	<20050804195853.0866ade9.akpm@osdl.org>
	<34082.213.188.237.106.1123228569.squirrel@localhost>
	<20050805010236.12d811ff.akpm@osdl.org>
	<006301c599ca$69410700$ab0e10ac@pinchy>
	<42F5F0B0.3050105@dgreaves.com>
	<012701c59c62$3db09d40$ab0e10ac@pinchy>
	<1123540166.17810.1.camel@star2.austin.ibm.com>
	<00b301c59d1b$5d5645a0$ab0e10ac@pinchy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Cuss on Tuesday August 9
Sender: linux-raid-owner@vger.kernel.org
To: Mark Cuss <mcuss@cdlsystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 9, mcuss@cdlsystems.com wrote:
> Hmm - Okay.  If I do that, I get "/dev/sdr1 does not appear to be an md 
> device".  If I add --force with this it doesn't seem to matter.
> 
...
> From: "Mike Tran" <mhtran@us.ibm.com>
> To: <linux-raid@vger.kernel.org>
> Sent: Monday, August 08, 2005 4:29 PM
> Subject: Re: How to force a spare drive to take over in a RAID5?
> 
> 
> > You're on the right track :) mdadm --fail /dev/sdr should do.

Ofcourse, What Mike meant was 
  mdadm /dev/md4 --fail /dev/sdr

NeilBrown

