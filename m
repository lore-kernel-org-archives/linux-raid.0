From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 13:06:27 +0500
Message-ID: <20170504130627.4f20f79c@natsu>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
        <20170503235856.GA9698@metamorpher.de>
        <20170504022258.eov6xh2zwtbfvcch@kernel.org>
        <20170504075551.GA3929@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170504075551.GA3929@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On Thu, 4 May 2017 09:55:51 +0200
Andreas Klauer <Andreas.Klauer@metamorpher.de> wrote:

> For example? I was under the impression that pretty much all of them do. 
> Even the ones that don't advertize it returned zero after trim for me. 
> [Sometimes you get original data but that's Linux; gone after drop_caches]
> (Of course, I don't have access to that many different models of SSD...)
> 
> But what do they actually return then? Original data?

Consult Wikipedia at least, if not the original ATA standards documents:
https://en.wikipedia.org/wiki/Trim_(computing)#ATA
Can return "undefined", "something that is the same every time" or "zeroes".
Apparently the OS can query which is to be expected with a particular device,
but firstly, you can't necessarily trust that 100%, and secondly, that's
operating on a level lower (ATA) than where md is.

-- 
With respect,
Roman
