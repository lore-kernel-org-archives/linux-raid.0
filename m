From: Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 21:52:20 +0100
Message-ID: <4F1DC884.40200@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>  <4F1D89B9.9080802@redhat.com> <1327338242.9581.0.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327338242.9581.0.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: Doug Ledford <dledford@redhat.com>, Jes.Sorensen@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

Heya,

On 23.01.2012 18:04, Krzysztof Adamski wrote:
> How about --prepivot

Note that pivot_root() is not involved in your boot process anymore, so 
this might be considered misleading.

Lennart
