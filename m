From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Wed, 04 Jul 2007 09:45:22 +0100
Message-ID: <468B5E22.7080805@dgreaves.com>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org> <468A98D5.9090206@dgreaves.com> <200707032129.10787.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707032129.10787.infomails@tronserver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Frotscher wrote:
> I forgot, in case it's of any help. 

Also do
mdadm --examine /dev/hd[abc]3

David
