From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid/device failure
Date: Mon, 11 Feb 2013 11:22:31 +0800
Message-ID: <511863F7.2090108@fnarfbargle.com>
References: <201302101827.36116.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302101827.36116.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/02/13 09:27, Thomas Fjellstrom wrote:

> sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected

The CRC error there is the key. Check your cables, backplane & PSU.


