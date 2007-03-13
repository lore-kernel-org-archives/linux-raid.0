From: Tomka Gergely <gergely@tomka.hu>
Subject: Re: sw raid0 read bottleneck
Date: Tue, 13 Mar 2007 18:34:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 13 Mar 2007, Justin Piszcz wrote:

> Have you tried increasing your readahead values for the md device?

Yes. No real change. According to my humble mental image, readahead not a 
too useful thing, when we read 1-4 thread with sdd. The io subsystem 
already reading with the possible maximum speed, so don't have time to 
read ahead. Correct me, if i wrong. 

-- 
Tomka Gergely, gergely@tomka.hu
