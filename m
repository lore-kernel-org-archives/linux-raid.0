From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid set limit of 27 disks
Date: Wed, 28 Jan 2004 12:43:44 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16407.5072.716031.730705@notabene.cse.unsw.edu.au>
References: <DD454AE0A9AA8442A0A4422E919E6C2B03F62F95@msgemeamb01.ads.autodesk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomas Hodan on Monday January 26
To: Tomas Hodan <tomas.hodan@discreet.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 26, tomas.hodan@discreet.com wrote:
> hi all,
> 
> how can I increase the 27 disks limit in one raid set ?

Not yet. 
The raid super-block only has room to list 27 component devices (it
wastes space badly).
2.6 has support for a new improved layout, but there is no user-space
support for this yet.

NeilBrown
