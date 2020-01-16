From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH, v2] Change warning message
Date: Thu, 16 Jan 2020 13:48:37 -0500
Message-ID: <b48dd5ba-639b-eba5-5386-899d317d3676@trained-monkey.org>
References: <20191210112121.20377-1-kinga.tanska@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20191210112121.20377-1-kinga.tanska@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/10/19 6:21 AM, Kinga Tanska wrote:
> In commit 039b7225e6 ("md: allow creation of mdNNN arrays via
> md_mod/parameters/new_array") support for name like mdNNN
> was added. Special warning, when kernel is unable to handle
> request, was added in commit 7105228e19
> ("mdadm/mdopen: create new function create_named_array for
> writing to new_array"), but it was not adequate enough,
> because in this situation mdadm tries to do it in old way.
> This commit changes warning to be more relevant when
> creating RAID container with "/dev/mdNNN" name and mdadm
> back to old approach.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Applied!

Thanks,
Jes
