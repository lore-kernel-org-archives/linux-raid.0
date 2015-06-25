From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Wed, 24 Jun 2015 21:03:52 -0400
Message-ID: <yq1oak438g7.fsf@sermon.lab.mkp.net>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
	<20150624100014.7d1e9842@natsu> <wrfj1th1tlis.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj1th1tlis.fsf@redhat.com> (Jes Sorensen's message of "Wed, 24
	Jun 2015 07:04:43 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Roman Mamedov <rm@romanrm.net>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jes" == Jes Sorensen <Jes.Sorensen@redhat.com> writes:

Jes> We already disable discard per default on raid456 in a similar
Jes> manner because some of them unreliably reports discard_zeroes_data
Jes> when they in reality don't.

Jes> If there was a way to reliably detect these things it would be
Jes> fine, unfortunately there isn't.

We whitelist drives that do the right thing now.

-- 
Martin K. Petersen	Oracle Linux Engineering
