From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Raid-5 to Raid-6 conversion?
Date: Tue, 30 Mar 2004 22:17:00 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c4crks$oub$1@terminus.zytor.com>
References: <405462FF.3000205@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <405462FF.3000205@wasp.net.au>
By author:    Brad Campbell <brad@wasp.net.au>
In newsgroup: linux.dev.raid
> 
> The crux of this is I'm going to max out my hardware capacity and add an extra 3 drives to this
> array (Trusting my life to raidreconf to expand the array).
> Is it feasible to at a later time add an extra disk and convert the raid-5 to a raid-6 on the fly ?
> 

It should be theoretically possible, but there is currently no code to do it.

	-hpa
