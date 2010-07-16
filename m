From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: regression:  hung boot upgrading to 2.6.34.1 from 2.6.32.11
Date: Fri, 16 Jul 2010 14:40:25 +0200
Message-ID: <4C405339.9030501@hiramoto.org>
References: <4C4025E0.8060701@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C4025E0.8060701@hiramoto.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I saw xfs was doing the barrier test.  so i mounted root with "nobarrier" and then my system booted 2.6.24




