#!/bin/sh

test_description="ipfs-update version and versions"

. lib/test-lib.sh

LOCAL_IPFS_UPDATE="../bin/ipfs-update"
GUEST_IPFS_UPDATE="sharness/bin/ipfs-update"

test_expect_success "ipfs-update binary is here" '
	test -f "$LOCAL_IPFS_UPDATE"
'

test_expect_success "'ipfs-update versions' works" '
	"$LOCAL_IPFS_UPDATE" versions >actual
'

test_expect_success "'ipfs-update versions' output looks good" '
	grep v0.14.0 actual &&
	grep v0.14.0-rc1 actual &&
	grep v0.36.0 actual
'

test_expect_success "start a docker container" '
	DOCID=$(start_docker)
'

test_expect_success "ipfs-update binary is on the container" '
	exec_docker "$DOCID" "test -f $GUEST_IPFS_UPDATE"
'

test_expect_success "'ipfs-update version' works" '
	exec_docker "$DOCID" "$GUEST_IPFS_UPDATE version" >actual
'

test_expect_success "'ipfs-update version' output looks good" '
	echo "none" >expected &&
	test_cmp expected actual
'

test_expect_success "'ipfs-update versions' works" '
	exec_docker "$DOCID" "$GUEST_IPFS_UPDATE versions" >actual
'

test_expect_success "'ipfs-update versions' output looks good" '
	grep v0.14.0 actual &&
	grep v0.14.0-rc1 actual &&
	grep v0.36.0 actual
'

test_expect_success "stop a docker container" '
	stop_docker "$DOCID"
'

test_done
