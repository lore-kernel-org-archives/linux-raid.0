From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Tue, 3 Oct 2017 13:59:15 +0500
Message-ID: <20171003135915.08eb53fd@natsu>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
        <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2 Oct 2017 19:29:34 +1100
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> I will not use SSDs with the card, so handling 8 HDDs should not be a
> stretch for either one?

Speaking of SSDs, handling *those* indeed will be a stretch, but for other
reasons. These cards are finicky about enabling TRIM support:
https://askubuntu.com/questions/416886/does-the-mpt2sas-driver-support-trim

I have an LSI 9212-4i and it also does not pass-through TRIM with a few SSDs
that I tried.

-- 
With respect,
Roman
