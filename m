From: Florian Dazinger <florian.dazinger@umit.at>
Subject: Re: problems with raid=noautodetect - solved
Date: Wed, 24 May 2006 14:47:33 +0200
Message-ID: <447455E5.8050908@umit.at>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.15774.526526.244768@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
> My first guess is that it isn't listing /dev/sdd? somehow.
> 
> Otherwise, can you add a '-v' to the mdadm command that assembles the
> array, and capture the output.  That might be helpful.
> 
> NeilBrown
> 
stupid me! I had a DEVICE section, but somehow forgot about my /dev/sdd 
drive.

sorry for the noise..

thanks,
florian
