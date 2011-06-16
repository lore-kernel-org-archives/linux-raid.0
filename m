From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: mdadm and disk failures
Date: Thu, 16 Jun 2011 12:39:57 +0800
Message-ID: <4DF9891D.7090604@fnarfbargle.com>
References: <4DF97A7B.1070901@dodtsair.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF97A7B.1070901@dodtsair.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Power <mpower@dodtsair.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/06/11 11:37, Mike Power wrote:
> Is the raid system capable of recovering and restoring bad blocks?
>
Yes, and it does so admirably. You will see a message in your system log to the effect that it had 
recovered the (or those) bad sector(s).

Brad
